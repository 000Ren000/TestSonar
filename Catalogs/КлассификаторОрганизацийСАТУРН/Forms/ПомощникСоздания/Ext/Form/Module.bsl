﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Организация     = Параметры.Организация;
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	ЖирныйШрифт     = Новый Шрифт(,, Истина);
	
	ЗаполнитьСписокДоступныхРолей();
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИнициализироватьПоляКонтактнойИнформации();
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		РежимИзменения = Истина;
		ОрганизацияПриИзмененииНаСервере();
		
	Иначе
		РежимИзменения = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения) Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ЗначенияЗаполнения);
		
	КонецЕсли;
	
	ОбновитьДоступныеСтатусыДляПерехода();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьРезультат") Тогда
		
		ПоказатьЗначение(, Организация);
		
	КонецЕсли;
	
КонецПроцедуры

#Область РедактированиеАдреса

&НаКлиенте
Процедура ЮридическийАдресПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		ЮрАдрес = "";
		Возврат;
	КонецЕсли;
	
	ЮридическийАдрес = Текст;
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформацииАдресаДоставки.
	ТекстСообщенияОбОшибке = ЮридическийАдресПриИзмененииНаСервере(Текст);
	
	Если ЗначениеЗаполнено(ТекстСообщенияОбОшибке) Тогда
		ОчиститьСообщения();
		ИмяПоля = "ЮридическийАдрес";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщенияОбОшибке,, ИмяПоля);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> ЮридическийАдрес Тогда
		ЮридическийАдрес   = Элемент.ТекстРедактирования;
		ЮрАдрес            = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           ЮрАдрес);
	ПараметрыОткрытия.Вставить("Представление",           ЮридическийАдрес);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес организации'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	ЮридическийАдрес = "";
	ЮрАдрес          = "";
	ДанныеЮрАдреса   = ДанныеЮридическогоАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	ЮридическийАдрес   = ВыбранноеЗначение.Представление;
	ЮрАдрес            = ВыбранноеЗначение.КонтактнаяИнформация;
	ДанныеЮрАдреса     = ДанныеЮридическогоАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		ФактАдрес = "";
		Возврат;
	КонецЕсли;
	
	ФактическийАдрес = Текст;
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформацииАдресаДоставки.
	ТекстСообщенияОбОшибке = ФактическийАдресПриИзмененииНаСервере(Текст);
	
	Если ЗначениеЗаполнено(ТекстСообщенияОбОшибке) Тогда
		ОчиститьСообщения();
		ИмяПоля = "ФактическийАдрес";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщенияОбОшибке,, ИмяПоля);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> ФактическийАдрес Тогда
		ФактическийАдрес   = Элемент.ТекстРедактирования;
		ФактАдрес          = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           ФактАдрес);
	ПараметрыОткрытия.Вставить("Представление",           ФактическийАдрес);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес организации'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	ФактическийАдрес = "";
	ФактАдрес        = "";
	ДанныеФактАдреса = ДанныеФактическогоАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	ФактическийАдрес   = ВыбранноеЗначение.Представление;
	ФактАдрес          = ВыбранноеЗначение.КонтактнаяИнформация;
	ДанныеФактАдреса   = ДанныеФактическогоАдресаКлиент();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаОрганизация
		И ПроверитьЗаполнение() Тогда
		
		ДанныеОрганизации = ИнтеграцияСАТУРНКлиентСервер.СтруктураДанныхОрганизации();
		
		ДанныеОрганизации.Наименование      = Наименование;
		ДанныеОрганизации.Ссылка            = Организация;
		ДанныеОрганизации.Идентификатор     = Идентификатор;
		ДанныеОрганизации.Email             = Email;
		ДанныеОрганизации.ИНН               = ИНН;
		ДанныеОрганизации.Телефон           = Телефон;
		ДанныеОрганизации.ФактическийАдрес  = ФактическийАдрес;
		ДанныеОрганизации.ЮридическийАдрес  = ЮридическийАдрес;
		ДанныеОрганизации.Статус            = Статус;
		ДанныеОрганизации.ОтветственноеЛицо = ОтветственноеЛицо;
		
		МассивУказанныхРолей = Новый Массив;
		
		Для Каждого ОписаниеЗначения Из СписокРолей Цикл
			
			Если Не ОписаниеЗначения.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			МассивУказанныхРолей.Добавить(ОписаниеЗначения.Значение);
			
		КонецЦикла;
		
		ДанныеОрганизации.МассивРолей = МассивУказанныхРолей;
		
		ПараметрыОбработкиКлассификаторов = ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыПередачиДанныхКлассификаторов();
		ПараметрыОбработкиКлассификаторов.Ссылка             = Организация;
		ПараметрыОбработкиКлассификаторов.ОрганизацияСАТУРН  = Организация;
		ПараметрыОбработкиКлассификаторов.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные");
		ПараметрыОбработкиКлассификаторов.Ссылка             = Организация;
		ПараметрыОбработкиКлассификаторов.ДополнительныеПараметры = Новый Структура();
		ПараметрыОбработкиКлассификаторов.ДополнительныеПараметры.Вставить("ДанныеОрганизации", ДанныеОрганизации);
		
		Если Статус <> ИсходныйСтатус Тогда
			
			ПараметрыОбработкиКлассификаторов.ДополнительныеПараметры.Вставить("НовыйСтатус", Статус);
		
		КонецЕсли;
		
		ОписаниеПриЗавершении = Новый ОписаниеОповещения(
			"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыОбработкиКлассификаторов);
		
		ОжиданиеРезультата = Истина;
		ИнтеграцияСАТУРНКлиент.ПодготовитьКПередаче(
			ЭтотОбъект,
			ПараметрыОбработкиКлассификаторов,
			ОписаниеПриЗавершении);

		ОбработатьРезультатОбменаСАТУРН();
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОрганизация;
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(Результат) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	ОжиданиеРезультата = Ложь;
	
	Если Результат.Количество() = 0 Тогда
		
		УправлениеЭлементамиФормы(ЭтотОбъект);
		Возврат;

	КонецЕсли;
	
	Для Каждого ЭлементОбработки Из Результат Цикл
		
		Если ЗначениеЗаполнено(ЭлементОбработки.ТекстОшибки) Тогда
			
			ВывестиИнформациюОбОшибке(ЭлементОбработки.ТекстОшибки);
			УправлениеЭлементамиФормы(ЭтотОбъект);
			
			Возврат;
			
		КонецЕсли;
		
		Если ЭлементОбработки.Объект.Количество() Тогда
			
			Организация = ЭлементОбработки.Объект[0];
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВывестиИнформациюОУспешномРезультатеОбмена();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	ОповеститьОбЗаписиОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСАТУРН()
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступныеСтатусыДляПерехода()
	
	СписокНовыхДоступныхЗначений = Элементы.Статус.СписокВыбора;
	СписокНовыхДоступныхЗначений.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		СписокНовыхДоступныхЗначений.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Черновик);
		СписокНовыхДоступныхЗначений.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Актуально);
		
		Статус = Перечисления.СтатусыОбъектовСАТУРН.Черновик;
		
	Иначе
		
		ШаблонПредставленияТекущегоВарианта = НСтр("ru = '%1 (текущий)'");
		ПредставлениеТекущегоВарианта       = СтрШаблон(ШаблонПредставленияТекущегоВарианта, Статус);
		
		Строки = Новый Массив;
		Строки.Добавить(Новый ФорматированнаяСтрока(ПредставлениеТекущегоВарианта, ЖирныйШрифт));
		
		СписокНовыхДоступныхЗначений.Добавить(Статус, Новый ФорматированнаяСтрока(Строки));
		
		Если Статус = Перечисления.СтатусыОбъектовСАТУРН.Черновик Тогда
		
			СписокНовыхДоступныхЗначений.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Актуально);
			СписокНовыхДоступныхЗначений.Добавить(Перечисления.СтатусыОбъектовСАТУРН.Отменен);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОбОшибке(ТекстОшибки)
	
	Строки = Новый Массив;
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'Ошибка:'")));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
		
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиИнформациюОУспешномРезультатеОбмена()
	
	Строки = Новый Массив;
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = 'На запрос о %1 организации %2 получен ответ.'"), СтрокаТипОперации("Получение"), Наименование)));
			
	Строки.Добавить(" ");
	Строки.Добавить(
		Новый ФорматированнаяСтрока(
			СтрШаблон(НСтр("ru = '%1 организация'"), СтрокаТипОперации("Завершено"))));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Организация),, ЦветГиперссылки,, "ОткрытьРезультат"));
	Строки.Добавить(".");
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросРезультат;
	
КонецПроцедуры

&НаКлиенте
Функция СтрокаТипОперации(СтадияОперации)

	ТипОперацииСтрокой = "";
	Если РежимИзменения Тогда
		Если СтадияОперации = "Завершено" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'Изменена'");
		ИначеЕсли СтадияОперации = "Получение" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'изменении'");
		КонецЕсли;
	Иначе
		Если СтадияОперации = "Завершено" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'Добавлена'");
		ИначеЕсли СтадияОперации = "Получение" Тогда
			ТипОперацииСтрокой = НСтр("ru = 'добавлении'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТипОперацииСтрокой;

КонецФункции

&НаКлиенте
Процедура ОповеститьОбЗаписиОбъектов()
	
	ПараметрОповещения = Организация;
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Организация, ПараметрОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийСАТУРН.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.КлассификаторОрганизацийСАТУРН КАК КлассификаторОрганизацийСАТУРН
	|ГДЕ
	|	КлассификаторОрганизацийСАТУРН.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		РезультатВыполненияЗапроса = ИнтерфейсСАТУРНВызовСервера.ОрганизацияПоИдентификатору(Выборка.Идентификатор);
		Если Не ПустаяСтрока(РезультатВыполненияЗапроса.ТекстОшибки) Тогда
			
			Строки = Новый Массив;
			Строки.Добавить(
				Новый ФорматированнаяСтрока(
					НСтр("ru = 'Ошибка:'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(РезультатВыполненияЗапроса.ТекстОшибки,, ЦветПроблема));
			
			ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка;
			
		Иначе
			
			ЭлементДанных = РезультатВыполненияЗапроса.Элемент;
			ДанныеОрганизации = ИнтерфейсСАТУРН.ДанныеОрганизации(ЭлементДанных);
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОрганизации);
			
			Для Каждого Роль Из ДанныеОрганизации.Роли Цикл
				
				СтрокаЗначенияРоли = СписокРолей.НайтиПоЗначению(Роль);
				
				Если СтрокаЗначенияРоли = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаЗначенияРоли.Пометка = Истина;
				
			КонецЦикла;
			
			ИсходныйСтатус = Статус;
			
			Если Не Статус = Перечисления.СтатусыОбъектовСАТУРН.Черновик Тогда
				
				ШаблонИнформации = НСтр("ru = 'Редактирование организации возможно только в статусе Черновик.
					|Организация переведена в статус %1, редактирование невозможно.'");
					
				ОписаниеОшибки = СтрШаблон(ШаблонИнформации, Статус);
				
				Строки = Новый Массив;
				Строки.Добавить(
					Новый ФорматированнаяСтрока(
						НСтр("ru = 'Информация:'")));
				Строки.Добавить(" ");
				Строки.Добавить(Новый ФорматированнаяСтрока(ОписаниеОшибки,, ЦветГиперссылки));
				
				ТекстИнформация = Новый ФорматированнаяСтрока(Строки);
				Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаИнформация;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Если Форма.РежимИзменения Тогда
		
		Форма.Заголовок = НСтр("ru = 'Изменение организации'");
		
	Иначе
		
		Форма.Заголовок = НСтр("ru = 'Создание организации'");
		
	КонецЕсли;
	
	УправлениеЭлементамиНавигацииПомощника(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхРолей()
	
	СписокРолей.Очистить();
	
	Для Каждого ДоступноеЗначение Из Метаданные.Перечисления.РолиКонтрагентовСАТУРН.ЗначенияПеречисления Цикл
		
		ЗначениеРоли = Перечисления.РолиКонтрагентовСАТУРН[ДоступноеЗначение.Имя];
		СписокРолей.Добавить(ЗначениеРоли, ДоступноеЗначение.Представление());
		
	КонецЦикла;
	
	СписокРолей.СортироватьПоПредставлению();
	Элементы.СписокРолей.ВысотаВСтрокахТаблицы = СписокРолей.Количество();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиНавигацииПомощника(Форма)

	Элементы = Форма.Элементы;
	Элементы.Закрыть.Заголовок = НСтр("ru = 'Закрыть'");
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОрганизация Тогда
		
		Если Форма.ОжиданиеРезультата Тогда
			
			Форма.Доступность = Ложь;
			
		Иначе
		
			Форма.Доступность = Истина;
		
			Элементы.Назад.Видимость   = Ложь;
			Элементы.Далее.Видимость   = Истина;
			Элементы.Закрыть.Видимость = Истина;
			Элементы.Далее.Заголовок   = НСтр("ru = 'Далее'");
			
			Элементы.Организация.Видимость = Форма.РежимИзменения;
			
		КонецЕсли;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросОшибка Тогда
		
		Форма.Доступность = Истина;
		
		Элементы.Назад.Видимость = Истина;
		Элементы.Далее.Видимость = Ложь;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗапросРезультат Тогда
		
		Форма.Доступность = Истина;
		
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		Элементы.Далее.Заголовок = НСтр("ru = 'Готово'");
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаИнформация Тогда
		
		Форма.Доступность = Истина;
		
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		
	КонецЕсли;

КонецПроцедуры

#Область РедактированиеАдреса

&НаКлиенте
Функция ДанныеЮридическогоАдресаКлиент(ОчищатьСообщения = Истина, Отказ = Ложь)
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(ЮрАдрес, ЮридическийАдрес);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Если ОчищатьСообщения Тогда
			ОчиститьСообщения();
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПредставлениеАдреса");
		ДанныеАдресаСтруктурой = Неопределено;
		
		Отказ = Истина;
	КонецПопытки;
	
	Возврат ДанныеАдресаСтруктурой;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	// Реквизит формы, контролирующий работу с адресом доставки.
	// Используемые поля аналогичны полям справочника ВидыКонтактнойИнформации.
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип",                          Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("АдресТолькоРоссийский",        Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
	// Считываем данные из полей адреса в реквизиты для редактирования.
	ЮридическийАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(ЮрАдрес);
	ФактическийАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(ФактАдрес);
	
КонецПроцедуры

&НаСервере
Функция ЮридическийАдресПриИзмененииНаСервере(Знач Представление)
	
	ТекстСообщенияОбОшибке = "";
	
	ЮрАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформацииАдреса);
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(ЮрАдрес, ЮридическийАдрес);
	Исключение
		ТекстСообщенияОбОшибке = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		ДанныеАдресаСтруктурой = Неопределено;
	КонецПопытки;
	
	ДанныеЮрАдреса = ДанныеАдресаСтруктурой;
	
	Возврат ТекстСообщенияОбОшибке;
	
КонецФункции

&НаКлиенте
Функция ДанныеФактическогоАдресаКлиент(ОчищатьСообщения = Истина, Отказ = Ложь)
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(ФактАдрес, ФактическийАдрес);
	Исключение
		ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Если ОчищатьСообщения Тогда
			ОчиститьСообщения();
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПредставлениеАдреса");
		ДанныеАдресаСтруктурой = Неопределено;
		
		Отказ = Истина;
	КонецПопытки;
	
	Возврат ДанныеАдресаСтруктурой;
	
КонецФункции

&НаСервере
Функция ФактическийАдресПриИзмененииНаСервере(Знач Представление)
	
	ТекстСообщенияОбОшибке = "";
	
	ЮрАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформацииАдреса);
	
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияСАТУРНВызовСервера.ДанныеАдресаПоАдресуXML(ФактАдрес, ФактическийАдрес);
	Исключение
		ТекстСообщенияОбОшибке = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		ДанныеАдресаСтруктурой = Неопределено;
	КонецПопытки;
	
	ДанныеФактАдреса = ДанныеАдресаСтруктурой;
	
	Возврат ТекстСообщенияОбОшибке;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти