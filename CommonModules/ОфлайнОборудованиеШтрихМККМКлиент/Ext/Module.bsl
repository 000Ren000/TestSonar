﻿
#Область ПрограммныйИнтерфейс

// Процедура начинает выполнение команды, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  Команда - Строка
//  ВходныеПараметры - Структура
//  ОбъектДрайвера - Структура
//  Параметры - Структура
//
Процедура НачатьВыполнениеКоманды(ОповещениеПриЗавершении, Команда, ВходныеПараметры, ОбъектДрайвера, Параметры) Экспорт
	
	ВыходныеПараметры = Новый Массив();
	
	Если Команда = "ВыгрузитьДанные" Тогда
		
		Товары				= ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист;
		ЧастичнаяВыгрузка	= НЕ ВходныеПараметры.ДанныеДляВыгрузки.ПрайсЛист.ПолнаяВыгрузка;
		РасширеннаяВыгрузка	= Истина;
		НачатьВыгрузкуТоваров(ОповещениеПриЗавершении, Параметры, Товары, ЧастичнаяВыгрузка, ВыходныеПараметры, РасширеннаяВыгрузка);
		
	ИначеЕсли Команда = "ЗагрузитьДанные" Тогда
		
		НачатьЗагрузкуРасширенногоОтчета(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Определяет результат загрузки отчета.
	ИначеЕсли Команда = "УстановитьФлагДанныеЗагружены" Тогда
		НачатьОтчетЗагружен(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Очистить базу ККМ Offline.
	ИначеЕсли Команда = "ОчиститьБазу" Тогда
		НачатьОчисткуТоваровНаККМ(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
		
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		Если ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АсинхронныеПроцедурыИФункции

#Область ВыгрузкаТоваров

// Процедура осуществляет выгрузку таблицы товаров в ККМ, подключенную в режиме Offline.
//
Процедура НачатьВыгрузкуТоваров(ОповещениеПриЗавершении, Параметры, Товары, ЧастичнаяВыгрузка, ВыходныеПараметры, РасширеннаяВыгрузка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ИмяФайла", Параметры.БазаТоваров);
	ДополнительныеПараметры.Вставить("ИмяФайлаФлага", Параметры.ФлагВыгрузки);
	ДополнительныеПараметры.Вставить("Товары", Товары);
	ДополнительныеПараметры.Вставить("РасширеннаяВыгрузка", РасширеннаяВыгрузка);
	ДополнительныеПараметры.Вставить("ЧастичнаяВыгрузка", ЧастичнаяВыгрузка);
	ДополнительныеПараметры.Вставить("ФорматОбмена", ?(Параметры.Свойство("ФорматОбмена"), Параметры.ФорматОбмена, 0));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ЧастичнаяВыгрузка Тогда
		НачатьПроверкуОбработанностиФайла(ОписаниеОповещения, Параметры.БазаТоваров); // Проверяем обработанность файла.
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина); // Продолжаем выгрузку.
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПроверкуОбработанностиФайла(ОписаниеОповещения, ИмяФайла) 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияПриЗавершении", ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	
	Файл = Новый Файл(ИмяФайла);
	
	ОписаниеОповещенияПриЗавершении = Новый ОписаниеОповещения("ПроверкаСуществованияФайлаПриПроверкеОбработанностиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл.НачатьПроверкуСуществования(ОписаниеОповещенияПриЗавершении);
	
КонецПроцедуры

Процедура ПроверкаСуществованияФайлаПриПроверкеОбработанностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещенияПриЗавершении = ДополнительныеПараметры.ОписаниеОповещенияПриЗавершении;
	
	Если Результат Тогда
		
		ИмяФайла = ДополнительныеПараметры.ИмяФайла;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОписаниеОповещенияПриЗавершении", ОписаниеОповещенияПриЗавершении);
		ОписаниеЗавершенияПолученияСодержания = Новый ОписаниеОповещения("ПроверкаОбработанностиФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИмяФайла, ОписаниеЗавершенияПолученияСодержания);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияПриЗавершении, Истина); // Файла не существует.
	КонецЕсли;
	
КонецПроцедуры

// Завершение
//
// Параметры:
//  Результат - Структура
//  ДополнительныеПараметры - Структура:
//   * ВыходныеПараметры - Структура
//   * ОписаниеОповещенияПриЗавершении - ОписаниеОповещения
Процедура ПроверкаОбработанностиФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = ДополнительныеПараметры.ОписаниеОповещенияПриЗавершении;
	
	Если Результат.Успешно Тогда
		
		#Если Не МобильноеПриложениеКлиент И Не МобильныйКлиент Тогда
		Файл = Новый ТекстовыйДокумент;
		Файл.УстановитьТекст(Результат.СодержаниеФайлов[0].ТекстСодержания);
		
		Строка = Файл.ПолучитьСтроку(2);
		
		Если СтрДлина(Строка) = 1 И Найти(Строка,"#") > 0 Тогда
			ОписаниеОповещения.ДополнительныеПараметры.ВыходныеПараметры.Добавить(999);
			ОписаниеОповещения.ДополнительныеПараметры.ВыходныеПараметры.Добавить(НСтр("ru='Нельзя сделать выгрузку. Товары предыдущей выгрузки еще не были получены ККМ-offline'"));
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь); // Нельзя если символ во второй строке "#".		
		Иначе
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина); // Можно если символ во второй строке не "#" (если загрузка произошла, там стоит "@").
		КонецЕсли;
		#КонецЕсли
		
	Иначе
		ОписаниеОповещения.ДополнительныеПараметры.ВыходныеПараметры.Добавить(999);
		ОписаниеОповещения.ДополнительныеПараметры.ВыходныеПараметры.Добавить(Результат.ТекстОшибки);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь); // Файл не прочитан, следовательно гарантировать обработанность файла нельзя.
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыгрузкуТоваровПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат Тогда
		
		ЧастичнаяВыгрузка = ДополнительныеПараметры.ЧастичнаяВыгрузка;
		РасширеннаяВыгрузка = ДополнительныеПараметры.РасширеннаяВыгрузка;
		Товары = ДополнительныеПараметры.Товары;
		ИмяФайла = ДополнительныеПараметры.ИмяФайла;
		ФорматОбмена = ДополнительныеПараметры.ФорматОбмена;
		
		ФайлТоваров = ФайлТоваров(РасширеннаяВыгрузка, ЧастичнаяВыгрузка, Товары, ФорматОбмена, ВыходныеПараметры);
		
		ДополнительныеПараметры.Вставить("ФайлТоваров", ФайлТоваров);
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ФайлТоваров.НачатьЗапись(ОписаниеОповещения, ИмяФайла, "windows-1251");
		
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыгрузкуТоваровЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат Тогда
		
		ФайлТоваров = ДополнительныеПараметры.ФайлТоваров;
		ФайлТоваров.Очистить();
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуТоваровПроверкаОбработанностиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ФайлТоваров.НачатьЗапись(ОписаниеОповещения, ДополнительныеПараметры.ИмяФайлаФлага, "windows-1251");
		
	Иначе
		
		ВыходныеПараметры.Добавить(999);
		ОписаниеОшибки = НСтр("ru='Не удалось записать файл товаров по адресу: %Адрес%'");
		ВыходныеПараметры.Добавить(СтрЗаменить(ОписаниеОшибки, "%Адрес%", ДополнительныеПараметры.ИмяФайла));
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыгрузкуТоваровПроверкаОбработанностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	Иначе
		
		ВыходныеПараметры.Добавить(999);
		ОписаниеОшибки = НСтр("ru='Не удалось записать файл товаров по адресу: %Адрес%'");
		ВыходныеПараметры.Добавить(СтрЗаменить(ОписаниеОшибки, "%Адрес%", ДополнительныеПараметры.ИмяФайлаФлага));
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаРасширенногоОтчета

Процедура НачатьЗагрузкуРасширенногоОтчета(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
	
	ИмяФайла = Параметры.ФайлОтчета;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	
	Файл = Новый Файл(ИмяФайла);
	
	ОписаниеОповещенияПриЗавершении = Новый ОписаниеОповещения("ПроверкаСуществованияФайлаПриЗагрузкеРасширенногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл.НачатьПроверкуСуществования(ОписаниеОповещенияПриЗавершении);
	
КонецПроцедуры

Процедура ПроверкаСуществованияФайлаПриЗагрузкеРасширенногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОповещениеПриЗавершении = ДополнительныеПараметры.ОповещениеПриЗавершении;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаРасширенногоОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИмяФайла, ОписаниеОповещения);
		
	Иначе
		
		ВыходныеПараметры.Добавить(999);
		ОписаниеОшибки = НСтр("ru='Файл %Адрес% не существует.'");
		ВыходныеПараметры.Добавить(СтрЗаменить(ОписаниеОшибки, "%Адрес%", ИмяФайла));
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузкаРасширенногоОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПриЗавершении;
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	ДанныеИзККМ = Неопределено;
	
	Если НЕ Результат.Успешно Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(Результат.ТекстОшибки);
		Результат = Ложь;
	Иначе
		
		ТекстИсправленный = СтрЗаменить(Результат.СодержаниеФайлов[0].ТекстСодержания, ОбщегоНазначенияБПОКлиентСервер.РазделительGS1(), ОбщегоНазначенияБПОКлиентСервер.ЭкранированныйСимволGS1());
		ТекстИсправленный = СтрЗаменить(ТекстИсправленный, МенеджерОфлайнОборудованияКлиентСервер.РазделительEOT(), МенеджерОфлайнОборудованияКлиентСервер.ЭкранированныйСимволEOT());
		ТекстИсправленный = СтрЗаменить(ТекстИсправленный, МенеджерОфлайнОборудованияКлиентСервер.РазделительRS(), МенеджерОфлайнОборудованияКлиентСервер.ЭкранированныйСимволRS());
		
		#Если Не МобильноеПриложениеКлиент И Не МобильныйКлиент Тогда
		Файл = Новый ТекстовыйДокумент();
		Файл.УстановитьТекст(ТекстИсправленный);
		
		Результат = РазобратьРасширенныйОтчет(Файл, ВыходныеПараметры);
		
		Если Результат Тогда
			ДанныеИзККМ = ВыходныеПараметры[0];
		КонецЕсли;
		#КонецЕсли
		
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры, ДанныеИзККМ", Результат, ВыходныеПараметры, ДанныеИзККМ);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ПометкаОтчета

// Функция вызывается после того, как был загружен и обработан отчет о продажах.
//
Процедура НачатьОтчетЗагружен(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры);
	
	ИмяФайла = Параметры.ФайлОтчета;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
	
	Файл = Новый Файл(ИмяФайла);
	
	ОписаниеОповещенияПриЗавершении = Новый ОписаниеОповещения("ПроверкаСуществованияФайлаПриПометкеОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл.НачатьПроверкуСуществования(ОписаниеОповещенияПриЗавершении);
	
КонецПроцедуры

Процедура ПроверкаСуществованияФайлаПриПометкеОтчетаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОповещениеПриЗавершении = ДополнительныеПараметры.ОповещениеПриЗавершении;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	
	Если Результат Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
		ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтчетЗагруженПродолжение", ЭтотОбъект, ДополнительныеПараметры);
		МенеджерОфлайнОборудованияКлиент.ПолучитьСодержаниеТекстовыхФайлов(ИмяФайла, ОписаниеОповещения);
		
	Иначе
		
		ВыходныеПараметры.Добавить(999);
		ОписаниеОшибки = НСтр("ru='Файл %Адрес% не существует.'");
		ВыходныеПараметры.Добавить(СтрЗаменить(ОписаниеОшибки, "%Адрес%", ИмяФайла));
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтчетЗагруженПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПриЗавершении;
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	ТекстОшибки = "";

	Если НЕ Результат.Успешно Тогда
		ТекстОшибки = Результат.ТекстОшибки;
		Результат = Ложь;
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
	Иначе
		
		ОписаниеОповещенияПометки = Новый ОписаниеОповещения("ОтчетЗагруженЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		#Если Не МобильноеПриложениеКлиент И Не МобильныйКлиент Тогда
		ТекстовыйДокументБазыТоваров = Новый ТекстовыйДокумент;
		ТекстовыйДокументБазыТоваров.УстановитьТекст(Результат.СодержаниеФайлов[0].ТекстСодержания);
		ТекстовыйДокументБазыТоваров.ЗаменитьСтроку(1, "@");
		
		ТекстовыйДокументБазыТоваров.НачатьЗапись(ОписаниеОповещенияПометки, ИмяФайла, "windows-1251");
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтчетЗагруженЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыходныеПараметры = ДополнительныеПараметры.ВыходныеПараметры;
	ОписаниеОповещения = ДополнительныеПараметры.ОповещениеПриЗавершении;
	ТекстОшибки = "";
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	
	Если НЕ Результат Тогда
		
		ТекстОшибки = НСтр("ru='Не удалось записать файл товаров по адресу: %Адрес%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Адрес%", ИмяФайла);
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
		
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОчисткаТоваров

// Процедура осуществляет очистку таблицы товаров в ККМ, подключенную в режиме Offline.
//
Процедура НачатьОчисткуТоваровНаККМ(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры, ОчисткаНастроек = Ложь)
	
	Файл = ОфлайнОборудованиеШтрихМККМВызовСервера.ФайлОчисткиДанных();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
	ДополнительныеПараметры.Вставить("ФлагВыгрузки", Параметры.ФлагВыгрузки);
	ДополнительныеПараметры.Вставить("ВыходныеПараметры", ВыходныеПараметры);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровНаККМПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл.НачатьЗапись(ОписаниеОповещения, Параметры.БазаТоваров, "windows-1251");
	
КонецПроцедуры

Процедура НачатьОчисткуТоваровНаККМПродолжение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		Если Не ПустаяСтрока(Параметры.ФлагВыгрузки) Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровНаККМЗавершение", ЭтотОбъект, Параметры);
		#Если Не МобильноеПриложениеКлиент И Не МобильныйКлиент Тогда
			Файл = Новый ТекстовыйДокумент();
			Файл.НачатьЗапись(ОписаниеОповещения, Параметры.ФлагВыгрузки, "windows-1251");
		#КонецЕсли
		Иначе
			РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, Параметры.ВыходныеПараметры);
			ВыполнитьОбработкуОповещения(Параметры.ОповещениеПриЗавершении, РезультатВыполнения);
		КонецЕсли;
	Иначе
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, Параметры.ВыходныеПараметры);
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеПриЗавершении, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьОчисткуТоваровНаККМЗавершение(Результат, Параметры) Экспорт
	
	ОписаниеОповещения = Параметры.ОповещениеПриЗавершении;
	
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, Параметры.ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ТестУстройства

// Процедура осуществляет тестирование устройства.
//
Процедура НачатьТестУстройства(ОповещениеПриЗавершении, Параметры, ВыходныеПараметры)
	
	Результат = ТестУстройства(Параметры, ВыходныеПараметры);
	РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Результат, ВыходныеПараметры);
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, РезультатВыполнения);
	
КонецПроцедуры

// Функция осуществляет проверку путей по которым хранятся файлы обмена.
//
Функция ТестУстройства(Параметры, ВыходныеПараметры) 
	
	Результат = Истина;
	ТекстОшибкиОбщий = "";
	ВремПараметр = "";
	
	Параметры.Свойство("БазаТоваров", ВремПараметр);
	
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = НСтр("ru='Файл базы товаров не указан.'");
	КонецЕсли;
	
	Параметры.Свойство("ФайлОтчета", ВремПараметр);
	Если ПустаяСтрока(ВремПараметр) Тогда
		Результат = Ложь;
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + ?(ПустаяСтрока(ТекстОшибкиОбщий), "", Символы.ПС); 
		ТекстОшибкиОбщий = ТекстОшибкиОбщий + НСтр("ru='Файл отчета не указан.'") 
	КонецЕсли;
	
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	Если НЕ ПустаяСтрока(ТекстОшибкиОбщий) Тогда
		ВыходныеПараметры.Добавить(ТекстОшибкиОбщий);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

Функция РазобратьРасширенныйОтчет(ТекстовыйДокумент, ВыходныеПараметры)
	
	Возврат ОфлайнОборудованиеШтрихМККМВызовСервера.ЗагружаемыеДанныеИзККМ(ТекстовыйДокумент, ВыходныеПараметры);
	
КонецФункции

Функция ФайлТоваров(РасширеннаяВыгрузка, ЧастичнаяВыгрузка, Товары, ФорматОбмена, ВыходныеПараметры)
	
	Возврат ОфлайнОборудованиеШтрихМККМВызовСервера.ВыгружаемыеДанныеВККМ(РасширеннаяВыгрузка, ЧастичнаяВыгрузка, Товары, ФорматОбмена, ВыходныеПараметры);
	
КонецФункции

#КонецОбласти