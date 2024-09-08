﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = Новый Структура;
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("ВозможнаНастройкаРасписания",  НЕ ОбщегоНазначения.РазделениеВключено() И Пользователи.ЭтоПолноправныйПользователь(, Истина));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	НачалоВеденияУправленческогоУчетаОрганизаций =
		?(ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций), 0, 1);
	
	// Настройки партионного учета
	ПериодДвиженийСебестоимости = ПартионныйУчетСервер.ПериодПервыхДвиженийРегистраСебестоимость();
	
	НастройкиПартионногоУчета();
	
	// Обновление состояния элементов
	УстановитьДоступность();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗначенияПоУмолчанию = Новый Структура;
	ОбщегоНазначенияУТКлиентСервер.СохранитьЗначенияДоИзменения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
		Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	ИначеЕсли (ТипЗнч(Источник) = Тип("Строка")
		И Найти(Источник, "ИспользоватьУправлениеПроизводством2_2") > 0) Тогда
		
		ЭтаФорма.Прочитать();
		НастройкиПартионногоУчета();
		УстановитьДоступность();
		
	КонецЕсли;
	
	Если Источник = ЭтаФорма Тогда
		Если Параметр.Свойство("Элемент") Тогда
			Подключаемый_ПриИзмененииРеквизита(Параметр.Элемент, Истина, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимПартионногоУчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РежимПартионногоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПереходаНаПартионныйУчетВерсии22ПриИзменении(Элемент)
	
	НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = НачалоМесяца(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22);
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ПериодДвиженийПУ22)
	 ИЛИ НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 <= ПериодДвиженийПУ22 Тогда
	 
		// Сдвиг даты "назад" допустим - переформируются остатки на новый период и дальше можно вести учет на ПУ 2.2.
		Если ЗначениеЗаполнено(ПериодДвиженийСебестоимости)
		 И НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 < ПериодДвиженийСебестоимости Тогда
			
			НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = ПериодДвиженийСебестоимости;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Указанный период не может быть раньше даты первых движений по регистрам: %1'"),
				Формат(ПериодДвиженийСебестоимости, "ДЛФ=Д"));
			
		КонецЕсли;
		
	Иначе
		
		// Сдвиг даты "вперед" недопустим - обратный переход с ПУ 2.2 на ПУ 2.1 не поддерживается.
		НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = ПериодДвиженийПУ22;
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Указанный период не может быть позже даты первых движений партионного учета версии 2.2: %1'"),
			Формат(ПериодДвиженийПУ22, "ДЛФ=Д"));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУправленческийУчетОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НачалоВеденияУправленческогоУчетаСОпределеннойДатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НачалоВеденияУправленческогоУчетаСНачальнойДатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВеденияУправленческогоУчетаОрганизацийПриИзменении(Элемент)
	
	НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НачалоМесяца(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций);
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина, ВнешнееИзменение = Ложь)
	
	Если НЕ ВнешнееИзменение Тогда
		НастройкиСистемыКлиентЛокализация.ПриИзмененииРеквизита_ФинансовыйРезультат(
			Элемент,
			ЭтаФорма);
	КонецЕсли;
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		
		КонстантаМенеджер 		 = Константы[КонстантаИмя];
		КонстантаЗначение 		 = НаборКонстант[КонстантаИмя];
		КонстантаПрошлоеЗначение = КонстантаМенеджер.Получить();
		
		Если КонстантаПрошлоеЗначение <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 И НаборКонстант.ВестиУправленческийУчетОрганизаций Тогда
		
		НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НачалоМесяца(ТекущаяДатаСеанса());
		Если НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций <= НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 Тогда
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Дата(1,1,1);
		КонецЕсли;
		
		НачалоВеденияУправленческогоУчетаОрганизаций =
			?(ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций), 0, 1);
		
		СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НачалоВеденияУправленческогоУчетаОрганизаций" Тогда
		
		Если РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций" Тогда
			
			Если НЕ ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций) Тогда
				НачалоВеденияУправленческогоУчетаОрганизаций = 1;
			КонецЕсли;
			
			Если НачалоВеденияУправленческогоУчетаОрганизаций = 0
			 И НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций < НачалоМесяца(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22) Тогда
				
				НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Макс(КонстантаПрошлоеЗначение, НачалоМесяца(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22));
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Указанный период должен быть позже даты начала использования партионного учета: %1'"),
					Формат(НачалоМесяца(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22), "ДЛФ=Д"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения, , "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
				
				СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если РеквизитПутьКДанным = "НачалоВеденияУправленческогоУчетаОрганизаций"
		 И НачалоВеденияУправленческогоУчетаОрганизаций = 0 Тогда
			
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НачалоМесяца(ТекущаяДатаСеанса());
			Если НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций <= НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 Тогда
				НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Дата(1,1,1);
			КонецЕсли;
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
	 		
		ИначеЕсли ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций)
		 И ((РеквизитПутьКДанным = "НачалоВеденияУправленческогоУчетаОрганизаций"
		 		И НачалоВеденияУправленческогоУчетаОрганизаций = 1)
		 	ИЛИ НЕ НаборКонстант.ВестиУправленческийУчетОрганизаций) Тогда
			
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Дата(1,1,1);
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
			
		КонецЕсли;
		
		ЗапланироватьПересчетСебестоимостиПриИзмененииУправленческогоУчетаОрганизаций();
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22" Тогда
		
		Если НаборКонстант.ВестиУправленческийУчетОрганизаций
		 И НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 > НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций Тогда
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22;
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
		КонецЕсли;
		
		ЗапланироватьПересчетСебестоимостиВерсии22();
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "РежимПартионногоУчета" Тогда
		
		ИзмененныеКонстанты = Новый Структура;
		
		Если РежимПартионногоУчета = "НеИспользуется" Тогда 
			
			// Отключение партионного учета.
			Если ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
				КонстантаИмя = "ИспользоватьПартионныйУчет";
				ИзмененныеКонстанты.Вставить("ИспользоватьПартионныйУчет", Ложь);
				Константы.ИспользоватьПартионныйУчет.Установить(Ложь);
			КонецЕсли;
			Если ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
				ИзмененныеКонстанты.Вставить("ПартионныйУчетВерсии22", Ложь);
				Константы.ПартионныйУчетВерсии22.Установить(Ложь);
			КонецЕсли;
			
			ЗапланироватьПересчетСебестоимостиПриОтключенииПУВерсии22();
			Обработки.ПервоначальноеЗаполнениеРегистровПартионногоУчета.ОтменаПроведенияДокументовПоРегистрамПартий();
			
		Иначе
			
			// Включение партионного учета.
			Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
				КонстантаИмя = "ИспользоватьПартионныйУчет";
				ИзмененныеКонстанты.Вставить("ИспользоватьПартионныйУчет", Истина);
				Константы.ИспользоватьПартионныйУчет.Установить(Истина);
			КонецЕсли;
			
			Если (РежимПартионногоУчета = "Версия22") <> ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
				
				// Включение партионного учета версии 2.2.
				КонстантаИмя = "ПартионныйУчетВерсии22";
				ИзмененныеКонстанты.Вставить("ПартионныйУчетВерсии22", РежимПартионногоУчета = "Версия22");
				Константы.ПартионныйУчетВерсии22.Установить(РежимПартионногоУчета = "Версия22");
			
				Если РежимПартионногоУчета = "Версия22" И НЕ ЗначениеЗаполнено(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22) Тогда
					
					// Если в ИБ есть движения, то установим дату перехода на этот месяц; если движений нет, то пусть дата остается пустой.
					Если ЗначениеЗаполнено(ПериодДвиженийСебестоимости) Тогда
						
						НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = НачалоМесяца(ТекущаяДатаСеанса());
						СохранитьЗначениеРеквизита("НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							НСтр("ru='Партионный учет версии 2.2. включен с текущего периода.
								|Установите требуемый период перехода на партионный учет версии 2.2.'"),
							,
							"НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Очистим дату перехода на партионный учет версии 2.2 если он не используется.
		Если НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22")
		 И ЗначениеЗаполнено(Константы.ДатаПереходаНаПартионныйУчетВерсии22.Получить()) Тогда
			
			НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = Дата(1,1,1);
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
			
		КонецЕсли;
		
		Для Каждого ТекКонстанта Из ИзмененныеКонстанты Цикл
			Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(ТекКонстанта.Ключ, ТекКонстанта.Значение) Тогда
				ЭтаФорма.Прочитать();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции	

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "РежимПартионногоУчета"
	 ИЛИ РеквизитПутьКДанным = "НачалоВеденияУправленческогоУчетаОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
	 
		Элементы.ГруппаИспользоватьПартионныйУчет.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости; 
		Элементы.ГруппаУправленческийУчетОрганизаций.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
		Элементы.ГруппаКомментарийВестиУправленческийУчетОрганизаций.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
		Элементы.ГруппаДатаНачалаВеденияУправленческогоУчетаОрганизаций.Доступность = НаборКонстант.ИспользоватьУчетСебестоимости;
	 
	 	Элементы.ДатаПереходаНаПартионныйУчетВерсии22.Видимость = (РежимПартионногоУчета = "Версия22");
		
		Элементы.НачалоВеденияУправленческогоУчетаСНачальнойДаты.Доступность = НаборКонстант.ВестиУправленческийУчетОрганизаций;
		Элементы.НачалоВеденияУправленческогоУчетаСОпределеннойДаты.Доступность = НаборКонстант.ВестиУправленческийУчетОрганизаций;
		
		ДоступностьВестиУправленческийУчетОрганизаций();
		
		УпрУчетСДаты = НаборКонстант.ВестиУправленческийУчетОрганизаций
			И (НачалоВеденияУправленческогоУчетаОрганизаций = 0);
		
		Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций.Доступность = УпрУчетСДаты;
		Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций.АвтоОтметкаНезаполненного = УпрУчетСДаты;
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура НастройкиПартионногоУчета()
	
	// Возможные значения реквизита РежимПартионногоУчета: "НеИспользуется", "Версия21", "Версия22".
	
	// Заполнение списка доступных режимов.
	ДоступныеРежимы = Элементы.РежимПартионногоУчета.СписокВыбора;
	ДоступныеРежимы.Очистить();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		РежимПартионногоУчета = "НеИспользуется";
	ИначеЕсли НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
		РежимПартионногоУчета = "Версия21";
	Иначе
		РежимПартионногоУчета = "Версия22";
	КонецЕсли;
	
	Если РежимПартионногоУчета = "Версия22" Тогда
		ПериодДвиженийПУ22		= ПартионныйУчетСервер.ПериодПервыхДвиженийПартионныйУчетВерсии22();
		ПричиныЗапретаПонижения = РасчетСебестоимостиПартионныйУчет21.ПартионныйУчетВерсии22НельзяПонизитьДоВерсии21(ЗначениеЗаполнено(ПериодДвиженийПУ22));
	Иначе
		ПричиныЗапретаПонижения = "";
	КонецЕсли;
	
	Если РежимПартионногоУчета = "НеИспользуется" Тогда
		ПричиныЗапретаВыключения = "";
	Иначе
		ПричиныЗапретаВыключения = ПартионныйУчетНельзяВыключать();
	КонецЕсли;
	
	Если РежимПартионногоУчета = "НеИспользуется" ИЛИ НЕ ЗначениеЗаполнено(ПричиныЗапретаВыключения) Тогда
		ДоступныеРежимы.Добавить("НеИспользуется", НСтр("ru='Не используется'"));
	КонецЕсли;
	
	Если (РежимПартионногоУчета = "Версия22" И НЕ ЗначениеЗаполнено(ПричиныЗапретаПонижения))
	 ИЛИ РежимПартионногоУчета = "Версия21" Тогда
		
		Если ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
			ИмяКонфигурации = НСтр("ru='ERP 2.1'");
		ИначеЕсли ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
			ИмяКонфигурации = НСтр("ru='КА 2.0'");
		Иначе
			ИмяКонфигурации = НСтр("ru='УТ 11.2'");
		КонецЕсли;
		
		ДоступныеРежимы.Добавить("Версия21",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Версия 2.1 (режим совместимости с %1)'"),
				ИмяКонфигурации));
		
	КонецЕсли;
	ДоступныеРежимы.Добавить("Версия22", НСтр("ru='Версия 2.2'"));
	
	// Описание причин ограничений выбора режимов.
	ТекстОграничения = "";
	
	Если РежимПартионногоУчета <> "НеИспользуется" И ЗначениеЗаполнено(ПричиныЗапретаВыключения) Тогда
		ТекстОграничения = ТекстОграничения + "
			|" + ПричиныЗапретаВыключения;
	КонецЕсли;
	
	Если РежимПартионногоУчета = "Версия22" И ЗначениеЗаполнено(ПричиныЗапретаПонижения) Тогда
		ТекстОграничения = ТекстОграничения + "
			|" + ПричиныЗапретаПонижения;
	КонецЕсли;
	
	// Установка свойств элементов формы.
	Элементы.РежимПартионногоУчета.Доступность 				  	   = (ДоступныеРежимы.Количество() > 1);
	Элементы.КомментарийИспользоватьПартионныйУчет.Заголовок 	   = СокрЛП(ТекстОграничения);
	Элементы.ГруппаКомментарийИспользоватьПартионныйУчет.Видимость = НЕ ПустаяСтрока(ТекстОграничения);
	
КонецПроцедуры

// Выполняет проверку возможности отключения партионного учета.
//
// Возвращаемое значение:
//	Строка - Текст предупреждения.
//
&НаСервере
Функция ПартионныйУчетНельзяВыключать()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК КодПричины
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Т
	|ГДЕ
	|	Т.МетодОценки = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|	И Т.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	2 КАК КодПричины
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаФинансовогоУчета КАК РегУчетнаяПолитика
	|ГДЕ
	|	РегУчетнаяПолитика.МетодОценкиСтоимостиТоваров = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	3 КАК КодПричины
	|ИЗ
	|	РегистрСведений.НастройкиУчетаНДС КАК РегУчетнаяПолитика
	|ГДЕ
	|	РегУчетнаяПолитика.ПрименяетсяУчетНДСПоФактическомуИспользованию
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодПричины
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстПредупреждения = "";
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.КодПричины = 1 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть документы ""Расчет себестоимости товаров"" с методом оценки стоимости товаров ""ФИФО (скользящая оценка)""'");
		ИначеЕсли Выборка.КодПричины = 2 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть организации с методом оценки стоимости товаров ""ФИФО (скользящая оценка)""'");
		ИначеЕсли Выборка.КодПричины = 3 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть организации, ведущие учет НДС по фактическому использованию'");
		Иначе
			ВызватьИсключение НСтр("ru='Неизвестный код причины.'");
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ТекстПредупреждения = НСтр("ru='Невозможно отключение партионного учета:'")
			+ ТекстПредупреждения;;
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

&НаСервере
Процедура ДоступностьВестиУправленческийУчетОрганизаций()

	КомментарийОпции = "";
	
	Если НаборКонстант.ВестиУправленческийУчетОрганизаций Тогда
	Иначе
		Если РежимПартионногоУчета <> "Версия22" Тогда
			КомментарийОпции = КомментарийОпции + Символы.ПС
				+ НСтр("ru = '- установить опции ""Партионный учет"" значение ""Версия 2.2""'");
		КонецЕсли; 
		Если ЗначениеЗаполнено(КомментарийОпции) Тогда
			КомментарийОпции = НСтр("ru = 'Для включения возможности использования управленческого учета по правилам МФУ необходимо:'") + КомментарийОпции;
		КонецЕсли; 
	КонецЕсли;
	НастройкиСистемыЛокализация.ДоступностьВестиУправленческийУчетОрганизаций(ЭтаФорма, КомментарийОпции);
	
	Если ЗначениеЗаполнено(КомментарийОпции) Тогда
		Элементы.КомментарийВестиУправленческийУчетОрганизаций.Заголовок = КомментарийОпции;
		Элементы.ГруппаКомментарийВестиУправленческийУчетОрганизаций.Видимость = Истина;
		Элементы.ВестиУправленческийУчетОрганизаций.Доступность = Ложь;
	Иначе
		Элементы.ГруппаКомментарийВестиУправленческийУчетОрганизаций.Видимость = Ложь;
		Элементы.ВестиУправленческийУчетОрганизаций.Доступность = Истина;
	КонецЕсли; 
		
КонецПроцедуры

// Создает задания к расчету себестоимости при изменении даты перехода на партионный учет версии 2.2.
//
&НаСервере
Процедура ЗапланироватьПересчетСебестоимостиВерсии22()
	
	Если НЕ РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаПереходаНаПартионныйУчетВерсии22",
		НачалоМесяца(Константы.ДатаПереходаНаПартионныйУчетВерсии22.Получить()));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) >= &ДатаПереходаНаПартионныйУчетВерсии22 И НЕ Т.ЕстьПереносДанных
	|			ТОГДА НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ)
	|		ИНАЧЕ &ДатаПереходаНаПартионныйУчетВерсии22
	|	КОНЕЦ КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		Т.Организация КАК Организация,
	|		МИНИМУМ(Т.Период) КАК Период,
	|		МАКСИМУМ(ВЫБОР
	|				КОГДА Т.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.СлужебноеПереходНаПартионныйУчет22)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ) КАК ЕстьПереносДанных
	|	ИЗ
	|		РегистрНакопления.СебестоимостьТоваров КАК Т
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Т.Организация) КАК Т
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	ПартионныйУчетСервер.СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

&НаСервере
Процедура ЗапланироватьПересчетСебестоимостиПриИзмененииУправленческогоУчетаОрганизаций()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СебестоимостьТоваров.Организация КАК Организация,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(СебестоимостьТоваров.Период, МЕСЯЦ)) КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО (ИСТИНА)
	|ГДЕ
	|	СебестоимостьТоваров.Период >= НАЧАЛОПЕРИОДА(Константы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций, МЕСЯЦ)
	|	И ВЫБОР КОГДА Константы.ВестиУправленческийУчетОрганизаций
	|		ТОГДА СебестоимостьТоваров.Период >= НАЧАЛОПЕРИОДА(Константы.ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
	|		ИНАЧЕ ИСТИНА
	|	 КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	СебестоимостьТоваров.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	ПартионныйУчетСервер.СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

// Создает задания к расчету себестоимости при отключении партионного учета версии 2.2.
//
&НаСервере
Процедура ЗапланироватьПересчетСебестоимостиПриОтключенииПУВерсии22()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СебестоимостьТоваров.Организация КАК Организация,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(СебестоимостьТоваров.Период, МЕСЯЦ)) КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	|ГДЕ
	|	СебестоимостьТоваров.Активность
	|	И НЕ СебестоимостьТоваров.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|	И (СебестоимостьТоваров.Партия <> НЕОПРЕДЕЛЕНО
	|		ИЛИ СебестоимостьТоваров.АналитикаУчетаПартий <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|		ИЛИ СебестоимостьТоваров.АналитикаФинансовогоУчета <> НЕОПРЕДЕЛЕНО
	|		ИЛИ СебестоимостьТоваров.ВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	СебестоимостьТоваров.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	ПартионныйУчетСервер.СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти